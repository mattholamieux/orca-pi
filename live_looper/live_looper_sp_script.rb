#Orca_Pi V.1#

use_bpm 60
T= 1.0


### MASTER ###

live_loop :master do
  v = sync "/osc/h"
  set_mixer_control! amp: v[0], amp_slide: v[1], lpf: v[2]*10, lpf_slide: v[3]
end

### LIVE AUDIO ###

live_loop :audio_in do
  use_real_time
  v = sync "/osc/g"
  a = v[0]
  b = v[1]
  c = v[2]
  d = v[3]
  e = v[4]
  f = v[5]
  g = v[6]
  h = v[7]
  i = v[8]
  j = v[9]
  k = v[10]
  with_fx :level, amp: k do
    with_fx :reverb, mix: a/10.0, room: b/10.0, damp: c/10.0 do
      with_fx :echo, mix: d/10.0, phase: e/4.0, decay: f do
        with_fx :bitcrusher, mix: g/10.0, bits: h, sample_rate: i*1000, cutoff: j*10 do
          with_fx :panslicer, mix: 1, phase: 4, wave: 2, smooth: 0.15 do
            live_audio :chan1, input: 2
          end
        end
      end
    end
  end
end

###RECORDERS###

live_loop :recorder1 do
  use_real_time
  v = sync "/osc/a"
  set :buff_len1, v[0]
  print "RECORDING BUFFER ONE, LEN: " + v[0].to_s + " CHAN: " + v[1].to_s
  with_fx :level, amp: 0 do
    with_fx :record, buffer: buffer(:buff_one, v[0]), pre_mix: 0, pre_mix_slide: 0.1 do |e|
      control e, pre_mix: 1
      live_audio :mic, input: v[1]
      sleep T*v[0]-0.1
      control e, pre_mix: 0
    end
  end
end

live_loop :recorder2  do
  use_real_time
  v = sync "/osc/b"
  set :buff_len2, v[0]
  print "RECORDING BUFFER TWO, LEN: " + v[0].to_s + " CHAN: " + v[1].to_s
  with_fx :level, amp: 0 do
    with_fx :record, buffer: buffer(:buff_two, v[0]), pre_mix: 0, pre_mix_slide: 0.1 do |e|
      control e, pre_mix: 1
      live_audio :mic, input: v[1]
      sleep T*v[0]-0.1
      control e, pre_mix: 0
    end
  end
end

live_loop :recorder3 do
  use_real_time
  v = sync "/osc/c"
  set :buff_len3, v[0]
  print "RECORDING BUFFER THREE, LEN: " + v[0].to_s + " CHAN: " + v[1].to_s
  with_fx :level, amp: 0 do
    with_fx :record, buffer: buffer(:buff_three, v[0]), pre_mix: 0, pre_mix_slide: 0.1 do |e|
      control e, pre_mix: 1
      live_audio :mic, input: v[1]
      sleep T*v[0]-0.1
      control e, pre_mix: 0
    end
  end
end

###LOOPERS###

live_loop :looper1 do
  v = sync "/osc/d"
  a = get[:buff_len1]
  b = v[0]
  c = v[1]
  d = v[2]
  f = v[3]
  h = v[4]
  i = v[5]
  j = v[6]
  k = v[7]
  g = v[8]
  l = v[9]
  buff = :buff_one
  with_fx :pitch_shift, mix: h/10.0, pitch: i, window_size: j/4.0 do
    sample buffer(buff, a), rate: b/4.0, rpitch: c, start: d/35.0, finish: f/35.0, amp: g if one_in(l)
  end
end

live_loop :looper2 do
  v = sync "/osc/e"
  a = get[:buff_len2]
  b = v[0]
  c = v[1]
  d = v[2]
  e = v[3]
  h = v[4]
  i = v[5]
  j = v[6]
  k = v[7]
  l = v[9]
  g = v[8]
  buff = :buff_two
  with_fx :pitch_shift, mix: h/10.0, pitch: i, window_size: j/4.0 do
    sample buffer(buff, a), rate: b/4.0, rpitch: c, start: d/35.0, finish: e/35.0, attack: 0.05, decay: 0.05, amp: g if one_in(l)
  end
end

live_loop :looper3 do
  v = sync "/osc/f"
  a = get[:buff_len3]
  b = v[0]
  c = v[1]
  d = v[2]
  e = v[3]
  g = v[7]
  l = v[8]
  h = v[4]
  i = v[5]
  j = v[6]
  slice_idx = (range d,e).tick
  slice_size = 0.0625
  s = slice_idx * slice_size
  st = s + slice_size
  buff = :buff_three
  with_fx :pitch_shift, mix: h/10.0, pitch: i, window_size: j/4.0, pitch_dis: 0.001, time_dis: 0.001 do
    sample buffer(buff, a), start: s, finish: st, rate: b/4.0, rpitch: c, attack: 0.05, release: 0.05, amp: g, pan: rrand(-1,1) if one_in(l)
  end
end






