require 'rails_helper'
require 'pundit/rspec'

RSpec.describe EventPolicy, type: :policy do
  let(:event_creator) { UserContext.new(User.new, {}) }
  let(:event) { Event.new(user: event_creator.user) }
  let(:event_with_pin) { Event.new(user: event_creator.user, pincode: '123') }
  let(:cookies) { { "events_#{event.id}_pincode" => '123' } }

  subject { described_class }

  context 'when an anonymous user' do
    let(:anonymous) { UserContext.new(nil, {}) }

    context 'when event without pin' do
      permissions :create?, :new?, :edit?, :update?, :destroy? do
        it { is_expected.not_to permit(anonymous, event) }
      end

      permissions :index?, :show? do
        it { is_expected.to permit(anonymous, event) }
      end
    end

    context 'when event with pin' do
      let(:anonymous_with_pin) { UserContext.new(nil, cookies) }

      permissions :index? do
        it { is_expected.to permit(anonymous, event_with_pin) }
      end

      permissions :show?, :create?, :new?, :edit?, :update?, :destroy? do
        it { is_expected.not_to permit(anonymous, event_with_pin) }
      end

      permissions :index?, :show? do
        it { is_expected.to permit(anonymous_with_pin, event_with_pin) }
      end

      permissions :create?, :new?, :edit?, :update?, :destroy? do
        it { is_expected.not_to permit(anonymous_with_pin, event_with_pin) }
      end
    end
  end

  context 'when an authorized user' do
    let(:user) { UserContext.new(User.new, {}) }

    context 'when event without pin' do
      permissions :new?, :create?, :index?, :show? do
        it { is_expected.to permit(user, event) }
      end

      permissions :edit?, :update?, :destroy? do
        it { is_expected.not_to permit(user, event) }
      end
    end

    context 'when event with pin' do
      let(:user_with_pin) { UserContext.new(User.new, cookies) }

      permissions :new?, :create?, :index? do
        it { is_expected.to permit(user, event_with_pin) }
      end

      permissions :show?, :edit?, :update?, :destroy? do
        it { is_expected.not_to permit(user, event_with_pin) }
      end

      permissions :new?, :create?, :index?, :show? do
        it { is_expected.to permit(user_with_pin, event_with_pin) }
      end

      permissions :edit?, :update?, :destroy? do
        it { is_expected.not_to permit(user_with_pin, event_with_pin) }
      end
    end
  end

  context 'when an authorized user event creator' do
    permissions :new?, :create?, :index?, :show?, :edit?, :update?, :destroy? do
      it { is_expected.to permit(event_creator, event) }
    end

    permissions :new?, :create?, :index?, :show?, :edit?, :update?, :destroy? do
      it { is_expected.to permit(event_creator, event_with_pin) }
    end
  end
end
