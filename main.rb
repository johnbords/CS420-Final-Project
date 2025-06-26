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
    @info = "Press Enter to add task. Press 1–9 to toggle. \nPress Shift+Task# to delete a task. ESC to exit." # Instruction text shown at bottom.
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


  def draw                             # Definition for drawing.
    @font.draw_text("Add Task: #{@input}_", 10, 10, 1)
    #Draw prompt and current input for the user to put

    @tasks.each_with_index do |task, i|  #Loop through tasks in index
      status = task.completed ? "[X]" : "[ ]"
      #Choose “[X]” if done, “[ ]” if not or it is for default
      @font.draw_text(
        "#{i+1}. #{status} #{task.title}",
        10,
        50 + i*25,
        1
      )                                #Drawing the each task of lines
    end

    @font.draw_text(
      @info,
      10,            # X pos
      height - 45,   # Y pos
      1,             # Z order
      1, 1,          # X/Y scale
      Gosu::Color::GRAY #Draw with the color gray.
    )
  end

  def button_down(id) #Definition for the keys
    if id == Gosu::KB_RETURN && !@input.strip.empty?
      #If Enter pressed and input isn’t blank:?
      @tasks << Task.new(@next_id, @input.strip)
      #It will create a new tasks and ID as well.
      @next_id += 1                     #Increment next ID.
      @text_input.text = ""            #It will clear the text
      save_tasks                       #Save the tasks po.

    elsif id >= Gosu::KB_1 && id <= Gosu::KB_9
      #If 1-9 are pressed then
      idx = id - Gosu::KB_1            # Convert key code to zero index.
      if button_down?(Gosu::KB_LEFT_SHIFT) ||
         button_down?(Gosu::KB_RIGHT_SHIFT)
        # If Shift held down for Left-shift or Right-shift
        if @tasks[idx]                #If that task exists then delete
          @tasks.delete_at(idx)
          save_tasks                  #save the tasks
        end
      else                             #Else for Without Shift:
        if task = @tasks[idx]         #if ever the tasks exist
          task.completed = !task.completed #Toggle its completed flag.
          save_tasks
        end
      end

    elsif id == Gosu::KB_ESCAPE         #If ESC is pressed
      close                            #Close the window and exit.
    end                                 #End of the main if.
  end

  def needs_cursor?                    #Override for the mouse cursor shows.
    true
  end
end

QuickTaskWindow.new.show               #Instantiate and run the GUI loop.

