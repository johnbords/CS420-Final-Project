require 'json' # Load Ruby’s JSON library so we can parse/generate JSON.

class Task
  attr_accessor :id, :title, :completed  # Auto-generate getter/setter methods for those three attributes.

  # The constructor
  def initialize(id, title, completed = false)
    @id = id  # Store the unique task ID
    @title = title  # Store the task’s title text
    @completed = completed  # (Boolean) Store whether it’s done
  end

  def to_h  # Convert this Task into a simple Ruby hash
    { id: @id, title: @title, completed: @completed }
  end

  def self.from_h(hash)  # Class method: build a Task from a hash.
    Task.new(hash['id'], hash['title'], hash['completed'])
  end
end
