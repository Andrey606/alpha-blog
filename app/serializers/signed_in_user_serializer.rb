class SignedInUserSerializer < UserSerializer
    attributes :current_key

    def current_key
      self.instance_options[:key].api_key
    end
end
