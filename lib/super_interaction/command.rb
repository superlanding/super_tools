module SuperInteraction
  class Command < Struct.new(:context)

    attr_accessor :commands

    delegate :helpers, to: :context

    def run
      context.render js: (commands || []).join(";")
    end

    def bs_notice(message)
      bs_alert('info', message)
      self
    end

    def bs_danger(message)
      bs_alert('danger', message)
      self
    end

    def bs_success(message)
      bs_alert('success', message)
    end

    def alert(message)
      cmd("alert('#{helpers.j(message)}');")
    end

    # modal 裡如果有 javascript 需寫在 .modal 層
    # size: sm / md / lg / xl / xxl
    # 注意：不要包 respond_to :js 會有問題
    def modal(partial: nil, size: 'md', title: '', desc: '')
      partial ||= context.action_name
      modal_html = context.render_to_string(partial, layout: "interaction_modal.html.haml", locals: { bs_modal_size: size, title: title, desc: desc })
      cmd("$(function() { $.modal.show('#{helpers.j(modal_html)}'); });")
    end

    # 關閉 Modal
    def close
      cmd("$.modal.close();")
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

    def bs_alert(class_type, text)
      cmd("if (typeof($.alert) == undefined) { alert('#{helpers.j(text)}'); } else { $.alert.#{class_type}('#{helpers.j(text)}'); }")
    end

    def cmd(js_code)
      self.commands ||= []
      self.commands.push(js_code)
      self
    end
  end
end
