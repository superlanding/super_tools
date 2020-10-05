module SuperInteraction
  class Beyond < Struct.new(:context)

    attr_accessor :commands

    delegate :helpers, to: :context

    def run
      context.render js: (commands || []).join(";")
    end

    def b_notice(message)
      b_alert('info', message)
      self
    end

    def b_danger(message)
      b_alert('danger', message)
      self
    end

    def b_success(message)
      b_alert('success', message)
    end

    def alert(message)
      cmd("alert('#{helpers.j(message)}');")
    end

    # modal 裡如果有 javascript 需寫在 .modal 層
    # size: sm / md / lg / xl / xxl
    # 注意：不要包 respond_to :js 會有問題
    def modal(partial: nil, size: 'md', title: '', desc: '')
      partial ||= context.action_name
      modal_html = context.render_to_string(partial, layout: "beyond.haml", locals: { modal_size: size, title: title, desc: desc })
      cmd("$(function() { $.uniqModal().modal('show', '#{helpers.j(modal_html)}'); });")
    end

    # 關閉 Modal
    def close
      cmd("$.uniqModal().modal('hide');")
    end

    # 重新讀取頁面
    def reload
      cmd("Turbolinks.visit(location.toString());");
    end

    # 導入頁面
    def redirect_to(url)
      cmd("Turbolinks.visit('#{url}');");
    end

    def modal_saved_rediret_to(message, redirect_url)
      close.alert(message).redirect_to(redirect_url)
    end

    def modal_saved_reload(message)
      close.alert(message).reload
    end

    def ajax_get(url)
      cmd("$.get('#{url}');")
    end

    def b_alert(class_type, text)
      cmd("if (typeof($.alert) == undefined) { alert('#{helpers.j(text)}'); } else { $.alert.#{class_type}('#{helpers.j(text)}'); }")
    end

    def cmd(js_code)
      self.commands ||= []
      self.commands.push(js_code)
      self
    end
  end
end
