module SuperInteraction
  class Engine < Rails::Engine
    paths["app/views"] = "lib/super_interaction/views"
  end
end
