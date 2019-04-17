require 'searchkick'
module SuperSearch
  class Scroll
    attr_accessor :expire_time, :size, :query

    # ScrollSearch.new(Member, '*', where: {}, order: {}, scroll: '5m', size: 10000)
    def initialize(model, term: '*', options: {})
      self.expire_time = options.delete(:scroll) || '5m'

      # 單次筆數不得超過 10000
      self.size = options.delete(:size).to_i

      # TODO: 這裏多搜尋一次，解決效能問題
      searchkick = model.search(term, { execute: false }.merge(options))
      self.query = Searchkick::Query.new(searchkick.klass, searchkick.term, searchkick.options)
      query_inject_hack
      query.setup_scroll(expire_time)
      query.setup_size(size)
    end

    # (hack) 改裝 Searchkick::Query
    def query_inject_hack
      query.instance_eval do
        # 設定遍歷參數
        def setup_scroll(scroll)
          @scroll_id = nil
          @scroll = scroll
        end

        # 設定遍歷 筆數/次
        def setup_size(size)
          @size = size
        end

        # searchkick/query line: 58
        def params
          options = { scroll: @scroll }
          options.merge!(body: { size: @size }) if @size <= 10000 && @size > 0
          super.deep_merge(options)
        end

        # searchkick/query line: 78
        def execute
          @execute = nil
          super
        end

        # searchkick/query line: 104
        def handle_response(response)
          # 從 response 設定 scroll ID
          @scroll_id = response['_scroll_id']
          super
        end

        # searchkick/query line: 205
        def execute_search
          # 第一次用原本的 search 來取 scroll id, 第二次以後 scroll id 跑 scroll api
          if @scroll_id.present?
            Searchkick.client.scroll(body: { scroll_id: @scroll_id }, scroll: @scroll)
          else
            Searchkick.client.search(params)
          end
        end
      end
    end

    # 開始遍歷搜尋
    def search(&block)
      while r = query.execute and not r.response['hits']['hits'].empty? do
          block.call(r.results, r.total_count) if block
        end
      end
    end
  end
end
