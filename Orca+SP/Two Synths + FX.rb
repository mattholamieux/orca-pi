### ORCA + SP 2 ###
use_bpm 100


live_loop :midi_one do
  v = sync "/osc/a"
  w = sync "/osc/b"
  
  a = v[0]/10.0 #attack
  d = v[1]/10.0 #decay
  s = v[2]/10.0 #sustain
  sl = v[3]/10.0 #sustain level
  r = v[4]/10.0 #release
  p = v[5]/10.0 - 1 #pan
  div = v[6]/2.0 #fm divisor
  dep = v[7] #fm depth

  emx = w[0]/10.0 #echo mix
  ed = w[1]/4.0+0.01 #echo decay
  ep = w[2]/4.0+0.01 #echo phase
  rmx = w[3]/10.0 #reverb mix
  rrm = w[4]/10.0 #reverb room
  rdm = w[5]/10.0 #reverb damp
  bcmx = w[6]/10.0 #bit crush mix
  bcb = w[7]+1 #bit crush bits
  bcsr = w[8]*1000 #bit crush sample rate
  
  
  use_real_time
  note, velocity = sync "/midi/iac_driver_iac_bus_2/1/1/note_on"
  use_synth :fm
  with_fx :reverb, mix: rmx, room: rrm, damp: rdm do
    with_fx :echo, mix: emx, decay: ed, phase: ep do
      with_fx :lpf, mix: 1, cutoff: 80 do
        with_fx :bitcrusher, mix: bcmx, bits: bcb, sample_rate: bcsr, cutoff: 0 do
          play note, amp: velocity/127.0, attack: a, decay: d, sustain: s, sustain_level: sl, release: r, pan: p, divisor: div, depth: dep
        end
      end
    end
  end
end

live_loop :midi_two do
  use_real_time
  note, velocity = sync "/midi/iac_driver_iac_bus_2/1/2/note_on"
  use_synth :dsaw
  with_fx :reverb , mix: 0.8, room: 0.9 do
    with_fx :ixi_techno, cutoff_max: 80, phase: 4, res: 0.3  do
      with_fx :pitch_shift, mix: 0.5, pitch: 7, window_size: 2 do
        play note, amp: velocity/127.0, attack: 1, sustain: 2, release: 2
      end
    end
  end
end






