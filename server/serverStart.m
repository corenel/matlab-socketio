addpath ./jsonlab/
addpath ../models/
run setup_lab_tanks.m

host='localhost';
port=5000;
s = server(host, port);
s.Q.empty();
s.receive();
len = 0;

while 1
    if not(s.Q.isempty()) && s.Q.size() > len
        data = s.Q.content;
        item = data(end);
        item_str = loadjson(item{1});
        if strcmp(item_str.name, 'repeat')
            message = struct('event', 'msg', 'name', 'Matlab', 'msg', item_str.msg);
            message_json = savejson('', message);
            s.send(message_json);
        end
        if strcmp(item_str.name, 'sim')
            run sim_tank_2_param.m;
            [time_stamp, L1, L2] = sim_tank_2(mdl,paramNameValStruct);
            sim_data = struct('event', 'chart', 'time', time_stamp, 'level_1', L1.data, 'level_2', L2.data);
            sim_data_json = savejson('', sim_data);
            % fprintf('%s', sim_data_json);
            % fprintf('----------');
            s.send(sim_data_json);
        end
        if strcmp(item_str.name, 'params')
            params = item_str.data;
            run sim_tank_2_param.m;
            sim_data = struct('event', 'params', 'status', 'success');
            sim_data_json = savejson('', sim_data);
            s.send(sim_data_json);
        end
        len = s.Q.size();
    end
end
