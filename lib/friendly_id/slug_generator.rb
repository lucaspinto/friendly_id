module FriendlyId
  # The default slug generator offers functionality to check slug candidates
  # for availability. In this fork we also check the slug table undependently
  # of their relations with an existing object since we can have slug which do
  # not have a relation anymore with an actual object.
  class SlugGenerator

    def initialize(scope, history_scope=nil)
      @scope = scope
      @history_scope = history_scope
    end

    def available?(slug)
      available = !@scope.exists_by_friendly_id?(slug)
      history_availble = @history_scope ?
        !@history_scope.find_by_slug(slug) :
        true

      available and history_availble
    end

    def generate(candidates)
      candidates.each {|c| return c if available?(c)}
      nil
    end

  end
end
