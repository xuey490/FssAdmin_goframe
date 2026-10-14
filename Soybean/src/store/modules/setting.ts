import { defineStore } from 'pinia';
import { computed } from 'vue';
import { useThemeStore } from './theme';

export const useSettingStore = defineStore('legacy-setting', () => {
  const themeStore = useThemeStore();

  const isDark = computed(() => themeStore.darkMode);
  const systemThemeColor = computed(() => themeStore.themeColors.primary);
  const menuType = computed(() => themeStore.layout.mode);

  return {
    isDark,
    systemThemeColor,
    menuType
  };
});

