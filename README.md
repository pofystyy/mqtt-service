## Usage

Add paths to build queues in MQTT broker
~~~yml
# mqtt_service/config/service.yml

:path:
  :topic: 'queue/broadcast'           # queue name for broadcast messaging.
  :device_token: 'queue/devices/'     # queue name for direct messaging. Should end '/' to add at the end device_token
~~~

Add settings line to connect to MQTT::Client
~~~yml
# mqtt_service/config/mqtt.yml

:mqtt:
  :host: 'localhost'
  :port: 8883
  :ssl: true
~~~
