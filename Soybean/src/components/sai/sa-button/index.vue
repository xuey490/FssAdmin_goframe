<!-- 表格按钮 -->
<template>
  <div>
    <el-tooltip :disabled="toolTip === ''" :content="toolTip" placement="top">
      <div
        :class="[
          'inline-flex items-center justify-center min-w-8 h-8 px-2.5 text-sm c-p rounded-md align-middle',
          buttonClass
        ]"
        :style="buttonStyle"
        @click="handleClick"
      >
        <Icon v-bind="bindAttrs" :icon="iconContent" class="art-svg-icon inline" />
      </div>
    </el-tooltip>
  </div>
</template>

<script setup lang="ts">
  import { computed, useAttrs } from 'vue'
  import { Icon } from '@iconify/vue'
  defineOptions({ name: 'SaButton' })

  interface Props {
    /** 按钮类型 */
    type?: 'primary' | 'secondary' | 'error' | 'info' | 'success'
    /** 按钮图标 */
    icon?: string
    /** 按钮工具提示 */
    toolTip?: string
    /** icon 颜色 */
    iconColor?: string
    /** 按钮背景色 */
    buttonBgColor?: string
  }

  const props = withDefaults(defineProps<Props>(), { toolTip: '' })

  const attrs = useAttrs()

  const bindAttrs = computed<{ class: string; style: string }>(() => ({
    class: (attrs.class as string) || '',
    style: (attrs.style as string) || ''
  }))

  const emit = defineEmits<{
    (e: 'click'): void
  }>()

  const typeStyles = {
    primary: {
      icon: 'ri:add-fill',
      class: 'bg-primary/12 text-primary',
      backgroundColor: 'var(--el-color-primary-light-9)',
      color: 'var(--el-color-primary)'
    },
    secondary: {
      icon: 'ri:pencil-line',
      class: 'bg-secondary/12 text-secondary',
      backgroundColor: 'rgba(113, 141, 255, 0.12)',
      color: '#718dff'
    },
    error: {
      icon: 'ri:delete-bin-5-line',
      class: 'bg-error/12 text-error',
      backgroundColor: 'var(--el-color-danger-light-9)',
      color: 'var(--el-color-danger)'
    },
    info: {
      icon: 'ri:more-2-fill',
      class: 'bg-info/12 text-info',
      backgroundColor: 'var(--el-color-info-light-9)',
      color: 'var(--el-color-info)'
    },
    success: {
      icon: 'ri:eye-line',
      class: 'bg-success/12 text-success',
      backgroundColor: 'var(--el-color-success-light-9)',
      color: 'var(--el-color-success)'
    }
  } as const

  // 获取图标内容
  const iconContent = computed(() => {
    return props.icon || (props.type ? typeStyles[props.type]?.icon : '') || ''
  })

  const buttonClass = computed(() => {
    return props.type ? typeStyles[props.type]?.class : ''
  })

  const buttonStyle = computed(() => {
    if (props.buttonBgColor || props.iconColor) {
      return {
        backgroundColor: props.buttonBgColor,
        color: props.iconColor
      }
    }

    if (!props.type) return {}

    const style = typeStyles[props.type]
    return {
      backgroundColor: style.backgroundColor,
      color: style.color
    }
  })

  const handleClick = () => {
    emit('click')
  }
</script>
