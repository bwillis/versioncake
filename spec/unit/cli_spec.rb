require 'spec_helper'

describe VersionCake::Cli do
  quiet_stdout
  before { allow(File).to receive :rename }

  context '#migrate' do
    subject(:migrated_files) { VersionCake::Cli.new.migrate(path) }

    context 'when a path has migratable files' do
      let(:path) { './spec/fixtures/templates' }

      it {
        renamed_files = [
          ['./spec/fixtures/templates/v1_extension_scheme.v3.html.erb',
            './spec/fixtures/templates/v1_extension_scheme.html.v3.erb'],
          ['./spec/fixtures/templates/v1_extension_scheme.v6.json',
            './spec/fixtures/templates/v1_extension_scheme.json.v6']
        ]
        expect(renamed_files).to match_array migrated_files
      }
    end

    context 'when a path has no migratable files' do
      let(:path) { './spec/test_app/app/views' }

      it { expect(migrated_files).to be_empty }
    end

    context 'when the path is not found' do
      let(:path) { './a/missing/path' }

      it { expect { migrated_files }.to raise_error(ArgumentError) }
    end
  end
end
