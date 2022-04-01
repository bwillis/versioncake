require './spec/rails_helper'

if ActionPack::VERSION::MAJOR == 7
  describe ActionView::Resolver::PathParser do
    let(:resolver) { ActionView::Resolver::PathParser.new }

    context '#extract_handler_and_format' do
      subject(:parsed_path) do
        resolver.parse("application.#{template_extension}")
      end

      context 'when only handler and format are present' do
        let(:template_extension) { 'html.erb' }

        it do
          expect(parsed_path.details.format).to eq :html
          expect(parsed_path.details.handler).to eq :erb
        end
      end

      context 'when handler, format and version are present' do
        let(:template_extension) { 'json.v1.builder' }

        it do
          expect(parsed_path.details.format).to eq :json
          expect(parsed_path.details.handler).to eq :builder
          expect(parsed_path.details.version).to eq :v1
        end
      end

      context 'when handler, format and locale are present' do
        let(:template_extension) { 'en.json.builder' }

        it do
          expect(parsed_path.details.locale).to eq :en
          expect(parsed_path.details.format).to eq :json
          expect(parsed_path.details.handler).to eq :builder
          expect(parsed_path.details.version).to eq nil
        end
      end

      context 'when handler, format, locale and version are present' do
        let(:template_extension) { 'en.json.v1.builder' }

        it do
          expect(parsed_path.details.format).to eq :json
          expect(parsed_path.details.handler).to eq :builder
          expect(parsed_path.details.version).to eq :v1
        end
      end

      context 'when handler, format, variant and version are present' do
        let(:template_extension) { 'json+tablet.v1.builder' }

        it do
          expect(parsed_path.details.variant).to eq :tablet
          expect(parsed_path.details.format).to eq :json
          expect(parsed_path.details.handler).to eq :builder
          expect(parsed_path.details.version).to eq :v1
        end
      end

      context 'when handler, format, variant, locale and version are present' do
        let(:template_extension) { 'en.json+tablet.v1.builder' }

        it do
          expect(parsed_path.details.locale).to eq :en
          expect(parsed_path.details.variant).to eq :tablet
          expect(parsed_path.details.format).to eq :json
          expect(parsed_path.details.handler).to eq :builder
          expect(parsed_path.details.version).to eq :v1
        end
      end
    end
  end
end
