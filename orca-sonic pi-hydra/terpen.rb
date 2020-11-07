
b1 = buffer(:foo, 2)

use_osc "localhost", 5100

use_bpm 60
T= 1.0

path = "/osc:127.0.0.1:55978/"

###RECORDERS###

live_loop :recorder1 do
  use_real_time
  v = sync path + "a"
  set :buff_len1, v[0]
  print "RECORDING BUFFER ONE, LEN: " + v[0].to_s + " CHAN: " + v[1].to_s
  with_fx :level, amp: 0 do
    with_fx :record, buffer: buffer(:buff_one, v[0]), pre_mix: 0, pre_mix_slide: 0.1 do |e|
      control e, pre_mix: 2
      live_audio :mic, input: v[1], stereo: true
      sleep T*v[0]-0.1
      control e, pre_mix: 0
    end
  end
end

live_loop :looper1 do
  v = sync  path + "b"
  amp = v[0]
  rate = v[1]/4.0
  strt = v[2]/35.0
  fin = v[3]/35.0
  with_fx :level, amp: 0 do
    with_fx :sound_out_stereo, output: 3 do
      sample buffer(:buff_one), amp: amp, rate: rate, start: strt, finish: fin, pan: rrand(-1,1)
    end
  end
end



live_loop :recorder2 do
 use_real_time
 v = sync path + "c"
 print "RECORDING BUFFER TWO, LEN: " + v[0].to_s + " CHAN: " + v[1].to_s
 with_fx :level, amp: 0 do
    with_fx :record, buffer: buffer(:buff_two, v[0]), pre_mix: 0, pre_mix_slide: 0.1 do |e|
      control e, pre_mix: 2
      live_audio :mic, input: v[1], stereo: true
      sleep T*v[0]-0.1
      control e, pre_mix: 0
    end
  end
end

live_loop :looper2 do
  v = sync path + "d"
  amp = v[0]
  rate = v[1]/4.0
  strt = v[2]/35.0
  fin = v[3]/35.0
  psmix = v[4]/8.0
  pspitch = v[5]
  pswin = v[6]
  with_fx :level, amp: 0 do
    with_fx :sound_out_stereo, output: 3 do
      with_fx :pitch_shift, mix: psmix, pitch: pspitch, window_size: pswin do
        sample buffer(:buff_two), amp: amp, rate: rate, start: strt, finish: fin, pan: rrand(-1,1)
      end
    end
  end
end


live_loop :recorder3 do
 use_real_time
 v = sync path + "f"
 print "RECORDING BUFFER THREE, LEN: " + v[0].to_s + " CHAN: " + v[1].to_s
 with_fx :level, amp: 0 do
    with_fx :record, buffer: b1, pre_mix: 0, pre_mix_slide: 0.1 do |e|
      control e, pre_mix: 2
      live_audio :mic, input: v[1], stereo: true
      sleep T*v[0]-0.1
      control e, pre_mix: 0
    end
  end
end

live_loop :looper3 do
  v = sync path + "g"
  amp = v[0]
  rate = v[1]/4.0
  strt = v[2]/35.0
  fin = v[3]/35.0 
  pitch = v[5]
  pstretch = v[7]
  with_fx :level, amp: 0 do
    with_fx :sound_out_stereo, output: 3 do
      sample b1, amp: amp, rate: rate, start: strt, finish: fin, rpitch: pitch, pitch_stretch: pstretch, pan: rrand(-1,1)
    end
  end
end


live_loop :viz1 do
  v = sync path + "z"
  if v[0] < 1
    osc '/one'
  else
    osc '/two'
  end
end

live_loop :viz2 do
  v = sync path + "w"
  osc '/three', v[1]
end

live_loop :viz3 do
  v = sync path + "x"
  if v[0] < 1
    osc '/four', 40
  else
    osc '/four', 0
  end
end

live_loop :viz4 do
  v = sync path + "u"
  if v[0] > 0
    osc '/five', v[0]
  end
  
end

