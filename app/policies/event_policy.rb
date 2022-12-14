class EventPolicy < ApplicationPolicy
  def show?
    pincode_guard
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  def update?
    @record.user == user
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def pincode_guard
    return true if @record.pincode.blank? || user == @record.user

    @record.pincode_valid?(cookies["events_#{@record.id}_pincode"])
  end
end
