module SuperInteraction
  if defined?(Rails::Engine)
    class Engine < Rails::Engine
      paths["app/views"] = "lib/super_interaction/views"

      # NOTE: 需要確認底下的程式有無作用
      # lib/super_interaction 底下並沒有 javascripts 目錄
      initializer 'beyond.assets.precompile' do |app|
        app.config.assets.paths << root.join('lib', 'super_interaction', 'javascripts').to_s
      end
    end
  end
end
