class Drone < ActiveRecord::Base
  # attr_accessible :title, :body



  REF_CONST = 290717696
  REF_EMERGENCY = 1 << 8
  REF_FLYING = 1 << 9

  def setup(ip, port)
    @drone_ip = ip
    @drone_control_port = port

    @application_id = 'RorARDrone'
    @user_id = 'bjarke'
    @session_id = "#{Socket.gethostname}:#{$$}"

    axis_reset

    config_ids @session_id, @user_id, @application_id
  end

  def format_cmd(cmd, data = nil)
    "#{cmd}=#{next_seq},#{data}\r"
  end

  def next_seq
    @seq = @seq.nil? ? 1 : @seq + 1
  end

  def push(msg)
    s = UDPSocket.new
    s.send msg, 0, @drone_ip, @drone_control_port unless msg.empty?
  end



  def state_msg
    push format_cmd *ref(@drone_state)
  end

  def axis_reset
    @phi, @theta, @yaw, @gaz = 0, 0, 0, 0
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
    axis_reset
    push format_cmd *flight
  end

  def gaz
    @gaz = 1036831949
    push format_cmd *flight
  end

  def pitch

  end

  def yaw

  end

  def roll

  end



  def configids(session_id, user_id, application_id)
    ['AT*CONFIG_IDS', "#{session_id},#{user_id},#{application_id}"]
  end

  def flight
    ['AT*PCMD', "1,#{@phi},#{@theta},#{@yaw},#{@gaz}"]
  end

  def ref(input)
    ['AT*REF', input.to_i | REF_CONST]
  end

end
