import {TurboModule} from 'react-native/Libraries/TurboModule/RCTExport';
import {TurboModuleRegistry} from 'react-native';
import { EventEmitter } from 'react-native/Libraries/Types/CodegenTypes';

export interface Spec extends TurboModule {
  sendMessage(message: string): void;
  getMessage(): Promise<string>;
  sendWithCallback(callback: (response: string) => void): void;

  addListener(eventName: string): void;
  removeListeners(count: number): void;
  startSendingEvents(): void;

  readonly onTimerTick: EventEmitter<{ message: string }>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('NativeMessageModule');

