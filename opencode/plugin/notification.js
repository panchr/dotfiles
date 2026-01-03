export const NotificationPlugin = async ({ $, directory }) => {
  const projectDir = directory ?? "unknown"

  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        await $`noti --title "opencode" --message "Waiting for user... (${projectDir})"`
      }
      if (event.type === "session.error") {
        await $`noti --title "opencode" --message "Session error (${projectDir})"`
      }
      if (event.type === "permission.updated") {
        await $`noti --title "opencode" --message "Waiting for permission... (${projectDir})"`
      }
    },
  }
}
