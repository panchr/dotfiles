export const NotificationPlugin = async ({ $, directory, client }) => {
  const projectDir = directory ?? "unknown";
  const sessionMeta = new Map();

  const track = (session) => {
    if (!session) return;
    sessionMeta.set(session.id, { subagent: Boolean(session.parentID) });
  };

  const isSubagent = async (sessionID) => {
    const cached = sessionMeta.get(sessionID);
    if (cached) return cached.subagent;
    const response = await client.session
      .get({ path: { id: sessionID } })
      .catch(() => undefined);
    const subagent = Boolean(response?.data?.parentID);
    sessionMeta.set(sessionID, { subagent });
    return subagent;
  };

  return {
    event: async ({ event }) => {
      if (event.type === "session.created") track(event.properties.info);
      if (event.type === "session.updated") track(event.properties.info);
      if (event.type === "session.deleted")
        sessionMeta.delete(event.properties.info.id);

      if (event.type === "session.idle") {
        // Only notify for primary sessions, not subagents.
        const subagent = await isSubagent(event.properties.sessionID);
        if (subagent) return;
        await $`noti --title "opencode" --message "Waiting for user... (${projectDir})"`;
      }
      if (event.type === "session.error") {
        await $`noti --title "opencode" --message "Session error (${projectDir})"`;
      }
      if (event.type === "permission.updated") {
        await $`noti --title "opencode" --message "Waiting for permission... (${projectDir})"`;
      }
    },
  };
};
