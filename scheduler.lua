Scheduler = class("Scheduler");

function Scheduler:initialize()
    self.time = 0;
    self.tasks = {};
end

function Scheduler:update(dt)
    self.time = self.time + dt;
    if(#self.tasks ~= 0) then
        for i, v in pairs(self.tasks) do
            if(self.time > v.alarm) then
                print("[Scheduler] Task run (" .. v.id .. ")");
                v.func();
                table.remove(self.tasks, i);
            end
        end
    end
end

function Scheduler:waitToRun(f, time)
    local t = {
        alarm = self.time + time,
        func = f,
        id = math.random(0, 100000)
    };
    table.insert(self.tasks, t);
    print("[Scheduler] Added task (" .. t.id ..  ") set to run at " .. refloat(self.time + time, 3) .. " (current time: " .. refloat(self.time, 3) .. ")");
end