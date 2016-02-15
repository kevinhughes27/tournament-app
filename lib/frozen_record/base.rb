module FrozenRecord
  class Base

    def self.read_file
      File.read(file_path)
    end

    def self.erb_file
      ERB.new(read_file).result
    end

    def self.load_records
      @records ||= begin
        records = YAML.load(erb_file) || []
        define_attributes!(list_attributes(records))
        records.map(&method(:new)).freeze
      end
    end
  end
end
