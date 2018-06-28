import ls from "local-storage";
const lsKey = "ScheduleEditorSettings";

interface UpdateSettings {
  scheduleStart?: number;
  scheduleEnd?: number;
  scheduleInc?: number;
  defaultGameLength?: number;
}

class Settings {
  scheduleStart: number = 8;
  scheduleEnd: number = 18;
  scheduleInc: number = 15; // minutes
  defaultGameLength: number = 90; // minutes

  constructor() {
    const userSettings = ls.get(lsKey) || {};
    Object.assign(this, userSettings);
  }

  scheduleLength() {
    return this.scheduleEnd - this.scheduleStart;
  }

  update(newSettings: UpdateSettings) {
    Object.assign(this, newSettings);
  }

  save() {
    ls.set(lsKey, this);
  }
}

const settings = new Settings();

export default settings;
