
INSERT INTO members (login_id, login_password, name, gender, phone_no, role) VALUES ('haha', 'hoho','Pakr', 'MALE', '01023145715', 'CHILD');
INSERT INTO members (login_id, login_password, name, gender, phone_no, role) VALUES ('momo', 'mama','kim', 'FEMALE', '01023145715', 'TEACHER');
INSERT INTO mission (title, content, grade) VALUES ('haha', 'hoho', 'GOLD');

INSERT INTO success_mission (member_id, mission_id) values (1, 1);
INSERT INTO stamp (MEMBER_MEMBER_ID, success_mission_id) VALUES (1, 1);