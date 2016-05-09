require 'spec_helper'

describe Answer do
  subject { described_class}

  let(:obj) { double }

  describe '#success?' do
    context 'nil' do
      context 'activerecord-like object with #errors' do
        let(:obj) { double(errors: errors) }

        context 'without errors' do
          let(:errors) { [] }

          it 'succeeds' do
            expect(subject.new(obj).success?).to eq(true)
          end
        end

        context 'with errors' do
          let(:errors) { { base: [ 'error' ] } }

          it 'fails' do
            expect(subject.new(obj).success?).to eq(false)
          end
        end
      end

      context 'object is nil' do
        it 'fails' do
          expect(subject.new(nil).success?).to eq(false)
        end
      end

      context 'object not responding to errors' do
        it 'defaults to true' do
          expect(subject.new(obj).success?).to eq(true)
        end
      end
    end

    context 'explicit value' do
      let(:success) { 'asdf' }

      it 'returns whatever boolean the value evaluates to' do
        expect(subject.new(obj, success).success?).to eq(!!success)
      end
    end
  end

  describe '#object' do
    context 'success' do
      it 'returns object' do
        expect(subject.new(obj).object).to eq(obj)
      end
    end

    context 'failure' do
      let(:errors) { { base: [ 'error' ] } }

      shared_examples 'error responder' do
        it 'returns a hash with errors' do
          expect(subject.new(obj, false).object).to eq(errors: errors)
        end
      end

      context 'responding to #errors' do
        let(:obj) { double(errors: errors) }

        it_behaves_like 'error responder'
      end

      context 'is a Hash' do
        let(:obj) { errors }

        it_behaves_like 'error responder'
      end

      context 'is an Array' do
        let(:obj) { errors[:base] }

        it_behaves_like 'error responder'
      end

      context 'is just a string' do
        let(:obj) { errors[:base].first }

        it_behaves_like 'error responder'
      end
    end

    context 'object is nil' do
      it 'returns a hash with an "error not found" message' do
        expect(subject.new(nil).object).to eq(
          errors: { base: ['Record not found'] }
        )
      end
    end
  end

  describe '#status' do
    context 'supplied status' do
      let(:success_does_not_matter) { [true, false].sample }
      let(:status) { 100 }

      it 'returns supplied status' do
        expect(subject.new(obj, success_does_not_matter, status).status).
          to eq(status)
      end
    end

    context 'status is nil' do
      context 'success' do
        it 'has status 200' do
          expect(subject.new(obj, true).status).to eq(200)
        end
      end

      context 'failure' do
        it 'has status 422' do
          expect(subject.new(obj, false).status).to eq(422)
        end
      end
    end

    context 'object is nil' do
      it 'has status 404' do
        expect(subject.new(nil).status).to eq(404)
      end
    end
  end

  describe '#render' do
    let(:controller) { double(params: params) }
    let(:params) { {} }
    let(:status) { 100 }

    it 'renders the object from the supplied controller' do
      expect(controller).to receive(:render).with(json: obj, status: status)

      subject.new(obj, true, status).render(controller)
    end

    context 'serializers' do
      let(:serializer) { double }

      context 'singular object' do
        it 'can specify a serializer' do
          expect(controller).to receive(:render).with(
            json: obj, status: status, serializer: serializer
          )

          subject.new(obj, true, status, serializer).render(controller)
        end
      end

      context 'enumerable object' do
        let(:obj) { [] }

        it 'can specify a serializer' do
          expect(controller).to receive(:render).with(
            json: instance_of(ActiveModel::ArraySerializer), status: status
          )

          subject.new(obj, true, status, serializer).render(controller)
        end
      end
    end

    context 'create action' do
      let(:params) { { action: 'create' } }

      it 'renders 201 if there was a success' do
        expect(controller).to receive(:render).with(json: obj, status: 201)

        subject.new(obj, true).render(controller)
      end
    end
  end
end
