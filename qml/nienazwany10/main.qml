import QtQuick 1.0
import Qt.labs.shaders 1.0
import QtMobility.sensors 1.1

 Rectangle {
     width: 845
     height: 480
     color: "black"
  id: gradientRect;

      property real orientacja_x : 0
      property real orientacja_y : 0
      property real orientacja_z : 0

  Accelerometer{
         id: xMeter
         active: true
         onReadingChanged: {

             orientacja_x = reading.x
             orientacja_y = reading.y
             orientacja_z = reading.z
    console.log("=====onReadingChanged========="+orientacja_x+" "+orientacja_y+" "+orientacja_z);
         }
     }




     Text {
         id: textLabel
         text: "Hello World"
         anchors.centerIn: parent
         font.pixelSize: 64
         color: "white"

     }
     Rectangle{
color: "black"
         id:cos
         anchors.fill: parent

     }

     ShaderEffectItem {
     id:kropeczka
     property variant source: ShaderEffectSource { sourceItem: cos; hideSource: true }
     property real wiggleAmount: 0.005
     property real time

     anchors.fill: cos

     NumberAnimation on time {
         easing.type: Easing.OutBounce
          from: 0
          to: 100
          duration: 3600
          loops: Animation.Infinite

        }
     fragmentShader: "
        varying highp vec2 qt_TexCoord0;
        uniform sampler2D source;
        uniform highp float wiggleAmount;
        uniform highp float time;
         varying highp vec2 pos;
    #define M_PI 3.14159265358979323846
   #pragma debug(on)

   const highp mat2 rotation = mat2(M_PI/4.0,M_PI/4.0,(M_PI/-4.0),M_PI/4.0);

        void main(void)
        {
       highp vec2 pos = mod((rotation) * gl_FragCoord.xy+time, vec2(50.0))-vec2(25.0);
       highp float dist_squared = dot (pos,pos);
   gl_FragColor= mix(vec4(0.90, 0.90, 0.90,1.0),vec4(0.20,0.20,0.40,1.0),smoothstep(380.25,420.25,dist_squared));
        }
        "
     }


     Image { id: img; x:(845/2)-img.width/2;y:(480/2)-img.height/2; sourceSize { width: 300; height: 300 } source: "images/ja.jpg" }

     ShaderEffectItem {
         width: 300; height: 300
         property variant source2: ShaderEffectSource{ sourceItem: img; hideSource: true }
       property real wiggleAmount2: 0.015
    property real wiggleAmount:orientacja_x/2

           anchors.fill: img
           NumberAnimation on wiggleAmount2 {
               easing.type: Easing.OutInQuart
                from: -0.05
                to: 0.05
                duration: 900
                loops: Animation.Infinite
              }
           fragmentShader:"
              varying highp vec2 qt_TexCoord0;
              uniform sampler2D source2;
              uniform highp float wiggleAmount;
              void main(void)
              {
                  highp vec2 wiggledTexCoord = qt_TexCoord0;
                  wiggledTexCoord.s += sin(2.0 * 3.141592653589 * wiggledTexCoord.t) * wiggleAmount;
                  gl_FragColor = texture2D(source2, wiggledTexCoord.st);
              }
              "

}
     Image {
         id: root
         x:200
         y:240
         z:10

         Image {
             id: pole
             anchors.horizontalCenter: parent.horizontalCenter
             anchors.top: parent.top
             source: "images/pole.png"
         }

         Image {

             MouseArea {
                 anchors.fill: parent
                 onClicked: wheel.rotation += 90
             }
             id: wheel
             anchors.centerIn: parent
             source: "images/pinwheel.png"
             Behavior on rotation {
                        NumberAnimation {
                            duration: 250
                        }
                    }
         }

     }
 }
