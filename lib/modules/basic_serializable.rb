# frozen_string_literal: false

# './lib/modules/basic_serializable'
module BasicSerializable
  @@serializer = Marshal

  def read_from(file_path)
    File.open(file_path, 'r')
  end

  def write_to(file_path)
    File.open(file_path, 'w')
  end

  def save_to_file(file_path, obj_string)
    file = write_to(file_path)
    file.write obj_string
    file.close
  end

  def load_saved_file(file_path)
    file = read_from(file_path)
    loaded = file.read
    file.close
    loaded
  end

  def serialize(obj)
    @@serializer.dump obj
  end

  def deserialize(string)
    @@serializer.load string
  end
end
