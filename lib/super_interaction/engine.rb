module SuperInteraction
  if defined?(Rails::Engine)
    class Engine < Rails::Engine
      paths["app/views"] = "lib/super_interaction/views"
    end
  end
end
