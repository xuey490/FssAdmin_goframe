import Draggable from 'vuedraggable-original';

type DraggableVNode = {
  el?: HTMLElement | null;
  component?: {
    subTree?: DraggableVNode & { children?: DraggableVNode[] };
  };
};

function resolveVnodeEl(node?: DraggableVNode | null): HTMLElement | null {
  if (!node) return null;
  if (node.el) return node.el;

  const subTree = node.component?.subTree;
  if (!subTree) return null;
  if (subTree.el) return subTree.el;

  if (Array.isArray(subTree.children)) {
    for (const child of subTree.children) {
      const el = resolveVnodeEl(child);
      if (el) return el;
    }
  }

  return null;
}

const draggableComponent = Draggable as typeof Draggable & {
  updated?: () => void;
};

const originalUpdated = draggableComponent.updated;

draggableComponent.updated = function patchedUpdated(this: {
  componentStructure?: {
    defaultNodes?: DraggableVNode[];
    realList?: unknown[];
  };
}) {
  const structure = this.componentStructure;
  const defaultNodes = structure?.defaultNodes;
  const realList = structure?.realList;

  if (!Array.isArray(defaultNodes) || !Array.isArray(realList)) {
    originalUpdated?.call(this);
    return;
  }

  defaultNodes.forEach((node, index) => {
    const el = resolveVnodeEl(node);
    if (!el) return;

    (el as HTMLElement & { __draggable_context?: { element: unknown; index: number } }).__draggable_context = {
      element: realList[index],
      index
    };
  });
};

export default draggableComponent;
