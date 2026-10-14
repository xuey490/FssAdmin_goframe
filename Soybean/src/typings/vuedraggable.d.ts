declare module 'vuedraggable-original' {
  import type { DefineComponent } from 'vue';

  const Draggable: DefineComponent<Record<string, unknown>, Record<string, unknown>, unknown>;
  export default Draggable;
}

declare module 'vuedraggable' {
  import type { DefineComponent } from 'vue';

  const Draggable: DefineComponent<Record<string, unknown>, Record<string, unknown>, unknown>;
  export default Draggable;
}
