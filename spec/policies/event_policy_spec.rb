require 'rails_helper'

RSpec.describe EventPolicy do
  subject { described_class }

  let(:user) { FactoryBot.create(:user) }
  let(:alien_user) { FactoryBot.create(:user) }

  let(:user_context) { UserContext.new(user, {}, '') }
  let(:alien_user_context) { UserContext.new(alien_user, {}, '') }
  let(:alien_user_context_with_correct_pin) { UserContext.new(alien_user, {}, 'qwerty') }
  let(:alien_user_context_with_wrong_pin) { UserContext.new(alien_user, {}, '123321') }

  let(:alien_user_context_with_correct_cookies) {
    UserContext.new(alien_user, { "events_#{event_with_pin.id}_pincode" => 'qwerty' }, '')
  }
  let(:alien_user_context_with_wrong_cookies) {
    UserContext.new(alien_user, { "events_#{event_with_pin.id}_pincode" => '123321' }, '')
  }
  let(:event) { FactoryBot.create(:event, user: user) }
  let(:event_with_pin) { FactoryBot.create(:event, user: user, pincode: 'qwerty') }

  permissions :update?, :edit?, :destroy? do
    it 'gives access if user is event author' do
      expect(subject).to permit(user_context, event)
    end

    it 'denies access if user is not event author' do
      expect(subject).not_to permit(alien_user_context, event)
    end
  end

  permissions :show? do
    context 'when user is event author' do
      it 'shows event' do
        expect(subject).to permit(user_context, event)
      end
    end

    context 'when event has no pincode' do
      it 'shows to any user' do
        expect(subject).to permit(alien_user_context, event)
      end
    end

    context 'when event is secured via pincode' do
      it 'requires pincode and doesnt show event' do
        expect(subject).not_to permit(alien_user_context, event_with_pin)
      end

      context 'when user has correct pincode' do
        it 'shows event' do
          expect(subject).to permit(alien_user_context_with_correct_pin, event_with_pin)
        end
      end

      context 'when user has bad pincode' do
        it 'doesnt show event' do
          expect(subject).not_to permit(alien_user_context_with_wrong_pin, event_with_pin)
        end
      end

      context 'when cookies have correct pincode' do
        it 'shows event' do
          expect(subject).to permit(alien_user_context_with_correct_cookies, event_with_pin)
        end
      end

      context 'when cookies have bad pincode' do
        it 'doesnt show event' do
          expect(subject).not_to permit(alien_user_context_with_wrong_cookies, event_with_pin)
        end
      end
    end
  end
end
