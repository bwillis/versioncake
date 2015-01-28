module VersionCake
  class VersionedRequest
    attr_reader :failed, :version

    def initialize(request, strategies, default_version=nil)
      @request, @strategies, @default_version, @failed = request, strategies, default_version, false
    end

    def execute
      begin
        extracted_version = extract_version

        if extracted_version.nil?
          @version = @default_version
        else
          @version = extracted_version
        end
      rescue Exception
        @failed = true
      end
    end

    private

    def extract_version
      extracted_version = nil
      @strategies.each do |strategy|
        extracted_version = strategy.extract(@request)
        break unless extracted_version.nil?
      end
      extracted_version
    end
  end
end
