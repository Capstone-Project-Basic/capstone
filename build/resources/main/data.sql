
INSERT INTO members (login_id, login_password, name, gender, phone_no, role) VALUES ('haha', 'hoho','Pakr', 'MALE', '01023145715', 'CHILD');
INSERT INTO members (login_id, login_password, name, gender, phone_no, role) VALUES ('momo', 'mama','kim', 'FEMALE', '01023145715', 'TEACHER');

INSERT INTO mission (title, content, grade, active_status) VALUES ('haha', 'hoho', 'GOLD', 'TRUE');
INSERT INTO mission (title, content, grade, active_status) VALUES ('공', '공 5개모아오기', 'SILVER', 'TRUE');

INSERT INTO success_mission (member_id, mission_id) values (1, 1);
INSERT INTO success_mission (member_id, mission_id) values (1, 2);

INSERT INTO stamp (MEMBER_MEMBER_ID, success_mission_id) VALUES (1, 1);