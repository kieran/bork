import React      from 'react'
import { render } from 'react-dom'

# more documentation available at
# https:#github.com/tensorflow/tfjs-models/tree/master/speech-commands

# the link to your model provided by Teachable Machine export panel
# MODEL_BASE = "https://teachablemachine.withgoogle.com/models/XtYABlXjq/"
MODEL_BASE = "https://teachablemachine.withgoogle.com/models/ckzoHU12u/"

class App extends React.Component
  constructor: ->
    super arguments...

    @state =
      loaded: false
      numBorks: 0
      borks: []

    @init()

  init: =>
    recognizer = await @createModel()
    recognizer.listen ({scores})=>
      if scores[1].toFixed(2) > 0.99
        @bork()
        console.log 'b0rk!'
    ,
      includeSpectrogram:               false # in case listen should return result.spectrogram
      probabilityThreshold:             0.95
      invokeCallbackOnNoiseAndUnknown:  true
      overlapFactor:                    0.50 # probably want between 0.5 and 0.75. More info in README

  bork: =>
    numBorks = @state.numBorks + 1
    borks = [ @state.borks..., new Date ]
    @setState { numBorks, borks }

  render: ->
    <div className="wow">
      {if @state.loaded
        <div>ready!</div>
        <h1>
          b0rks: {@state.numBorks}
          <ul>
            {<li>{"#{bork}"}</li> for bork in @state.borks}
          </ul>
        </h1>
      else
        <div>loading...</div>
      }
    </div>

  createModel: =>
    recognizer = speechCommands.create(
      "BROWSER_FFT", # fourier transform type, not useful to change
      undefined, # speech commands vocabulary feature, not useful for your models
      "#{MODEL_BASE}model.json",
      "#{MODEL_BASE}metadata.json",
    )
    # check that model and metadata are loaded via HTTPS requests.
    await recognizer.ensureModelLoaded()
    @setState loaded: true
    recognizer

    # Stop the recognition in 5 seconds.
    # setTimeout(() => recognizer.stopListening(), 5000);

render <App/>, document.getElementById 'application'
