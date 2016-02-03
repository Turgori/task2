class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :create, Event

      can [:show, :edit, :destroy], Event do |event|
        event.user_id == user.id
      end

      can :show, Event do |event|
        !event.private?
      end
    end
  end
end
