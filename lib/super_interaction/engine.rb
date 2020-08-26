module SuperInteraction
  class Engine < Rails::Engine
    paths["app/views"] = "lib/super_interaction/views"

    initializer 'beyond.assets.precompile' do |app|
      app.config.assets.paths << root.join('lib', 'super_interaction', 'javascripts').to_s
    end
  end
end
