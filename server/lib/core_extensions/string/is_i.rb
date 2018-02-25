module CoreExtensions
  module String
    module IsI
      def is_i?
        /\A[-+]?\d+\z/ === self
      end
    end
  end
end
