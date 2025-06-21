import React, {useState, useEffect} from 'react';
import {
  View,
  Button,
  Text,
  StyleSheet,
  NativeEventEmitter,
  NativeModules,
} from 'react-native';
import NativeMessageModule from './specs/NativeMessageModule';

const App = () => {
  const [receivedMessage, setReceivedMessage] = useState('');
  const [lastSentMessage, setLastSentMessage] = useState('');
  const [callbackMsg, setCallbackMsg] = useState('');
  const [eventMsg, setEventMsg] = useState('');

  useEffect(() => {
    const eventEmitter = new NativeEventEmitter(
      NativeModules.NativeMessageModule,
    );
    const subscription = eventEmitter.addListener('onTimerTick', event => {
      console.log('Event received:', event.message);
      setEventMsg(event.message);
    });
    return () => subscription?.remove();
  }, []);

  const startListening = () => {
    NativeMessageModule.startSendingEvents();
  };

  const sendMessageToNative = () => {
    const message = 'Hello from React Native';
    NativeMessageModule.sendMessage(message);
    setLastSentMessage(message);
  };

  const getMessageFromNative = () => {
    try {
      const message = NativeMessageModule.getMessage();
      setReceivedMessage(message);
    } catch (error) {
      console.error(error);
    }
  };

  const useCallbackMessage = () => {
    NativeMessageModule.sendWithCallback(msg => {
      setCallbackMsg(msg);
    });
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Bridging Example</Text>

      <View style={styles.buttonContainer}>
        <Button title="Send Message to Native" onPress={sendMessageToNative} />
        <Text style={styles.message}>Last sent: {lastSentMessage}</Text>
      </View>

      <View style={styles.buttonContainer}>
        <Button
          title="Get Message from Native"
          onPress={getMessageFromNative}
        />
        <Text style={styles.message}>Received: {receivedMessage}</Text>
      </View>

      <View>
        <Button title="Use Callback" onPress={useCallbackMessage} />
        <Text>Received: {callbackMsg}</Text>
      </View>

      <View>
        <Button title="Trigger Native Event" onPress={startListening} />
        <Text>Received: {eventMsg}</Text>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {flex: 1, justifyContent: 'center', padding: 16},
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 32,
    textAlign: 'center',
  },
  buttonContainer: {marginBottom: 24},
  message: {marginTop: 8, fontSize: 14, color: '#666'},
});

export default App;
