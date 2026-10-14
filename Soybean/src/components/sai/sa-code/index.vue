<template>
  <pre class="code-pre" :style="{ maxHeight: maxHeight }"><code class="hljs" v-html="highlightedCode"></code></pre>
</template>

<script setup lang="ts">
import { onMounted, ref, watch } from 'vue';
import hljs from 'highlight.js';
import 'highlight.js/styles/github-dark.css';

const props = defineProps({
  code: {
    type: String,
    required: true
  },
  language: {
    type: String,
    default: 'javascript'
  },
  maxHeight: {
    type: String,
    default: '720px'
  }
});

const highlightedCode = ref('');

const doHighlight = () => {
  if (!props.code) {
    highlightedCode.value = '';
    return;
  }
  try {
    highlightedCode.value = hljs.highlight(props.code, {
      language: props.language,
      ignoreIllegals: true
    }).value;
  } catch {
    highlightedCode.value = props.code
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }
};

watch(() => [props.code, props.language], doHighlight);
onMounted(doHighlight);
</script>

<style scoped>
.code-pre {
  border-radius: 8px;
  overflow: auto;
  font-size: 14px;
  line-height: 1.5;
}
</style>
