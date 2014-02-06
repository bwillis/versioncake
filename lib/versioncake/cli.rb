module VersionCake
  class Cli
    RAILS_VIEW_PATH = 'app/views'
    HANDLERS = %w(
      haml
      erb
      jbuilder
      rabl
      builder
    )

    def migrate(path)
      path = RAILS_VIEW_PATH unless path
      raise ArgumentError.new("No directory exists for '#{path}'") unless File.exists? path

      files_to_rename = []
      Dir.glob(File.join(path, '**/*.*')).each do |filename|
        if has_version_in_name?(filename) && new_name = v1_to_v2_filename(filename)
          files_to_rename << [filename, new_name]
        end
      end

      if files_to_rename.empty?
        puts 'No files to rename'
      end

      files_to_rename.each do |names|
        old_name, new_name = names
        puts "Renaming #{old_name} to #{new_name}"
        File.rename(old_name, new_name)
      end

      files_to_rename
    end

    def v1_to_v2_filename(path)
      filename = File.basename(path)
      if m = filename.match(/(\.v[0-9]+)/)
        version_str = m[0]
        new_path = path.sub version_str, ''

        if new_path.end_with? *HANDLERS
          # handler exists at the end, need to put the version before it
          parts = new_path.split('.')
          new_path = parts.insert(parts.length-1, version_str.delete('.')).join('.')
        else
          # no handler, version is the last extension
          new_path << version_str
        end

        path != new_path ? new_path : nil
      end
    end

    def has_version_in_name?(filename)
      filename =~ /v[0-9]+/
    end

  end
end