# Loads Gosu library for GUI and Task class from task.rb
require 'gosu'
require_relative 'task'

class QuickTaskWindow < Gosu::Window  # Define a window subclass to build our GUI.

  # The constructor
  def initialize
    super 500, 500  # Call Gosu::Window constructor with width=500, height=500
    self.caption = "QuickTask GUI"

    @font = Gosu::Font.new(20)  # Create a font at size 20 for drawing text.
    @tasks = load_tasks  # Load existing tasks from disk.
    @next_id = @tasks.map(&:id).max.to_i + 1  # Compute next task ID.
    @info = "Press Enter to add task. Press 1–9 to toggle.
            \nPress Shift+Task# to delete a task. ESC to exit." # Instruction text shown at bottom.
    @input = ""  # For user input
    @text_input = Gosu::TextInput.new  # Gosu object to capture text entry.
    self.text_input = @text_input  # Attach it so keystrokes go into @text_input.
  end

  def load_tasks  # Method for reading tasks.json.
    if File.exist?("tasks.json")
      JSON.parse(File.read("tasks.json"))  # Read and parse JSON…
          .map { |h| Task.from_h(h) }  # …then convert each hash to a Task.
    else
      []  # If no file, start with an empty list.
    end
  end

  def save_tasks  # Method for writing tasks.json.
    File.write(
      "tasks.json",
      JSON.pretty_generate(@tasks.map(&:to_h))
    )  # Serialize each Task to a hash and write JSON.
  end

  def update  # Method to be called every frame before draw.
    @input = @text_input.text  # Sync @input with the current text field.
  end
end
QuickTaskWindow.new.show