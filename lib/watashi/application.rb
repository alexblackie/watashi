module Watashi
  class Application < Yokunai::Application

    def call(env)
      # Support legacy "shtml" URLs
      if env["PATH_INFO"].end_with?(".shtml")
        new_path = env["PATH_INFO"].gsub(/\.shtml/, "")
        return [301, {"Location" => new_path}, [""]]
      end

      super
    end

  end
end
