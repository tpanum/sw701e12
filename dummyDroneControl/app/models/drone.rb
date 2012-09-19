class Drone < ActiveRecord::Base
  # attr_accessible :title, :body

  REF_CONST = 290717696
  REF_EMERGENCY = 1 << 8
  REF_FLYING = 1 << 9
  REF_CONTROLPORT = 5556

  def setup
    @drone_ip = self.ip_address
    @drone_control_port = REF_CONTROLPORT

    @application_id = 'RorARDrone'
    @user_id = 'bjarke'
    @session_id = "#{Socket.gethostname}:#{$$}"

    config_ids @session_id, @user_id, @application_id
    reset_axis
  end

  def format_cmd(cmd, data = nil)
    "#{cmd}=#{next_seq},#{data}\r"
  end

  def next_seq
    self.seq += 1
    self.save
    self.seq
  end

  def push(msg)
    s = UDPSocket.new
    puts msg
    s.send msg, 0, @drone_ip, @drone_control_port unless msg.empty?
  end



  def state_msg
    push format_cmd *ref(@drone_state)
  end

  def float2int(float)
    [float.to_f].pack('e').unpack('l').first
  end

  def reset_axis
    @phi, @theta, @yaw, @gaz = 0, 0, 0, 0
  end

  def send_reset_axis
    steer(@phi, @theta, @gaz, @yaw) if [@phi, @theta, @gaz, @yaw].any? {|i| i != 0 }
  end

  def minmax(min, max, *args)
    args.map {|arg| arg < min ? min : arg > max ? max : arg }
  end

  def steer(phi, theta, gaz, yaw)
    # Set bit zero to one to make the drone process inputs
    flags = 1 << 0
    push format_cmd *pcmd(flags, phi, theta, gaz, yaw)
  end

  def config_ids(session_id, user_id, application_id)
    push format_cmd *configids(session_id, user_id, application_id)
  end



  def takeoff
    @drone_state = REF_FLYING
    state_msg
  end

  def land
    @drone_state = 0
    state_msg
  end

  def hover
    flags = 0
    push format_cmd *pcmd(flags, 0, 0, 0, 0)
  end

  # def forward
    # @pitch = REF_ZEROONE
    # push format_cmd *flight
  # end

  # def backward
    # @pitch = REF_NEGZEROONE
    # push format_cmd *flight
  # end

  # def turnLeft
    # @yaw = REF_ZEROONE
    # push format_cmd *flight
  # end

  # def turnRight
    # @yaw = REF_NEGZEROONE
    # push format_cmd *flight
  # end

  # def up
    # @gaz = REF_ZEROONE
    # push format_cmd *flight
  # end

  # def down
    # @gaz = REF_NEGZEROONE
    # push format_cmd *flight
  # end


  def configids(session_id, user_id, application_id)
    ['AT*CONFIG_IDS', "#{session_id},#{user_id},#{application_id}"]
  end

  def pcmd(flags, phi, theta, gaz, yaw)
    values = [flags]

    # Ensure the inputs do not exceed [-1.0, 1.0]
    phi, theta, gaz, yaw = minmax -1.0, 1.0, phi, theta, gaz, yaw

    # Convert the values to IEEE 754, then cast to a signed int
    values += [phi, theta, gaz, yaw].map { |v|
      float2int v
    }
    ['AT*PCMD', values.join(',')]
  end

  def ref(input)
    ['AT*REF', input.to_i | REF_CONST]
  end

end
