function [color, text] = colorControl(a, h_res)
if a == 1
    color = get(h_res.state1,'ForegroundColor');
    text = get(h_res.state1,'String');
elseif a == 2
    color = get(h_res.state2,'ForegroundColor');
    text = get(h_res.state2,'String');
elseif a == 3
    color = get(h_res.state3,'ForegroundColor');
    text = get(h_res.state3,'String');
elseif a == 4
    color = get(h_res.state4,'ForegroundColor');
    text = get(h_res.state4,'String');
elseif a == 5
    color = get(h_res.state5,'ForegroundColor');
    text = get(h_res.state5,'String');
else
    errordlg('Something go wrong. Please, contact the technical support.','Error')
end
end