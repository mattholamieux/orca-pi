vid1 = document.createElement('video')
vid1.autoplay = true
vid1.loop = true
vid1.src = atom.project.getPaths()[0]+'/stone.mp4'

msg.setPort(5100)

msg.on('/one', (args) => {
 // console.log('one')
 s0.init({src: vid1})
 src(s0)
 .diff(o2)
 .modulate(o0)
 .luma(0.5)
 .diff(o1)
 .add(o3)
 .out(o0)
})


msg.on('/two', (args) => {
  console.log('two')
  osc(1,0.5,1)
  .add(o2)
  .pixelate(10,10)
  .out(o0)
})


msg.on('/three', (args) => {
  console.log('three '+ args)
  src(s0)
  // .add(o2)
  .diff(o1)
  .scale(args[0]*0.005)
  .modulate(o0)
  .rotate(0.5)
  .out(o0)
})

s1.init({src: vid2})

msg.on('/four', (args) => {
  console.log('four ' + args)
  shape(4,0.9)
    .mult(osc(4,0.25,1))
    .modulateRepeatY(osc(1), 5.0, ({time}) => Math.sin(time) * 0.5)
    .scale(1,0.5,0.05)
  .repeat(args[0],args[0])
  .out(o3)
})

msg.on('/five', (args) => {
  console.log('five')
 shape(3.1, (Math.sin(time) + 1) * 0.2, 0.1)
 .diff(o2)
 .modulate(o1)
  .out(o0)
})

s3.initScreen(2)
src(s3).out(o1)

osc(1,1,1)
.modulatePixelate(noise(5,0.5),1)
.out(o2)

render(o0)
