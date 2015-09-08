
//PIN
	d_pin_minmax=[3,30];			//	d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);			
	h_pin_minmax=[0,100];			//	h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);

//LEGS & FOOTS
	d_leg_minmax=[10,30];			//	d_leg=lim(d_leg_minmax[0],leg[0],d_leg_minmax[1]);
	h_leg_minmax=[20,90];			//	h_leg=lim(h_leg_minmax[0],leg[1],h_leg_minmax[1]);	
	n_leg_minmax=[4,16];			//	n_leg=lim(n_leg_minmax[0],leg[2],n_leg_minmax[1]);
	legsposition_minmax=[0,100];	// 	legsposition=lim(legsposition_minmax[0],leg[1],legsposition_minmax[1]);

	l_foot_minmax=[24,70];		//	l_foot=lim(l_foot_minmax[0],foot[0],l_foot_minmax[1]);
	h_foot_minmax=[0,40];			//	h_foot=lim(h_foot_minmax[0],foot[1],h_foot_minmax[1]);

	//MULTILEGS
	h1_pelvis_minmax=[3,50];		//	h1_pelvis=lim(h1_pelvis_minmax[0],h_pelvis[0],h1_pelvis_minmax[1]);
	h2_pelvis_minmax=[10,50];		//	h2_pelvis=lim(h2_pelvis_minmax[0],h_pelvis[1],h2_pelvis_minmax[1]);

	d1_pelvis_minmax=[20,100];	//	d1_pelvis=lim(d1_pelvis_minmax[0],d_pelvis[0],d1_pelvis_minmax[1]);
	d2_pelvis_minmax=[5,80];		//	d2_pelvis=lim(d2_pelvis_minmax[0],d_pelvis[1],d1_pelvis-5);
	
	n_multilegs_minmax=[3,8];		//	n_multilegs=lim(n_multilegs_minmax[0],n,n_multilegs_minmax[1]);

	l1_leg_minmax=[5,60];			//	l1_leg=lim(l1_leg_minmax[0],l_leg[0],l1_leg_minmax[1]);
	l2_leg_minmax=[5,60];			//	l2_leg=lim(l2_leg_minmax[0],l_leg[1],l2_leg_minmax[1]);
	ang1_leg_minmax=[0,90];		//	ang1_leg=lim(ang1_leg_minmax[0],ang_leg[0],ang1_leg_minmax[1]);
	ang2_leg_minmax=[0,90];		//	ang2_leg=lim(ang2_leg_minmax[0],ang_leg[1],ang2_leg_minmax[1]);



//HIP | WAIST
	//C
	d_hip_minmax=[25,80];			//	d_hip=lim(d_hip_minmax[0],hip[0],d_hip_minmax[1]);
	h_hip_minmax=[10,70];			//	h_hip=lim(h_pin+2,hip[1],h_hip_minmax[1]);
	f_hip_minmax=[0,100];			//	f_hip=lim(f_hip_minmax[0],hip[2],f_hip_minmax[1]);

								//	d1_waist=lim(d_pin,waist[0],d_hip);
								//	d2_waist=lim(d_pin,waist[1],d1_waist);
	h_waist_minmax=[0.3,20];		//	h_waist=lim(h_waist_minmax[0],waist[2],h_waist_minmax[1]);

	
	//Q
	x_hip_minmax=[20,90];			//	x_hip=lim(x_hip_minmax[0],hip[0],x_hip_minmax[1]);
	y_hip_minmax=[20,60];			//	y_hip=lim(y_hip_minmax[0],hip[1],y_hip_minmax[1]);
	z_hip_minmax=[10,60];			//	z_hip=lim(z_hip_minmax[0],hip[2],z_hip_minmax[1]);
	bevel_hip_minmax=[0.5,20];	//	bevel_hip=lim(bevel_hip_minmax[0],hip[3],bevel_hip_minmax[1]);

	n_waist_minmax=[4,50];		//	n_waist=lim(n_waist_minmax[0],waist[3],n_waist_minmax[1]);
								//	d1_waist=lim(d_pin,waist[0],min(x_hip,y_hip));
								//	d2_waist=lim(d_pin,waist[1],d1_waist);


//TRUNK | SHOULDER | NECK
	//C
	d1_trunk_minmax=[30,100];		//	d1_trunk=lim(d1_trunk_minmax[0],trunk[0],d1_trunk_minmax[1]); 
	d2_trunk_minmax=[30,100];		//	d2_trunk=lim(d2_trunk_minmax[0],trunk[1],d1_trunk);
	h_trunk_minmax=[24,100];		//	h_trunk=lim(h_trunk_minmax[0],trunk[2],h_trunk_minmax[1]);

	d1_shoulder_minmax=[12,50];	//	d1_shoulder=lim(d1_shoulder_minmax[0],shoulder[0],h_trunk*sin(angle_trunk));
	d_aux_shoulder_minmax=[0,10];	//	d_aux_shoulder=lim(d_aux_shoulder_minmax[0],shoulder[1],d_aux_shoulder_minmax[1]);
	h_shoulder_minmax=[0,50];		//	h_shoulder=lim(h_shoulder_minmax[0],shoulder[2],d2_trunk/2);

								//	d1_neck=lim(d_pin+2,neck[0],d2_trunk);
								//	d2_neck=lim(d_pin+2,neck[1],d1_neck);
	h_neck_minmax=[0.3,20];		//	h_neck=lim(h_neck_minmax[0],neck[2],h_neck_minmax[1]);

	//Q
	x_trunk_minmax=[20,90];		//	x_trunk=lim(x_trunk_minmax[0],trunk[0],x_trunk_minmax[1]);
	y_trunk_minmax=[20,90];		//	y_trunk=lim(d_pin+1+x_trunk/5,trunk[1],y_trunk_minmax[1]);
	z_trunk_minmax=[26,90];		//	z_trunk=lim(z_trunk_minmax[0],trunk[2],z_trunk_minmax[1]);
	
	n_neck_minmax=[4,50];			//	n_neck=lim(n_neck_minmax[0],neck[3],n_neck_minmax[1]);
								//	d1_neck=lim(d_pin+2,neck[0],min(x_trunk,y_trunk));	
								//	d2_neck=lim(d_pin+2,neck[1],d1_neck);

	//ELECTRIC TRUNK
	d_polygonal_trunk_minmax=[45,80];	//d_polygonal_trunk=lim(d_polygonal_trunk_minmax[0],trunk[0],d_polygonal_trunk_minmax[1]);							
	h_polygonal_trunk_minmax=[87,120];	//h_polygonal_trunk=lim(h_polygonal_trunk_minmax[0],trunk[1],h_polygonal_trunk_minmax[1]);
	thickness_trunk_minmax=[1,6];	//thickness_trunk=lim(thickness_trunk_minmax[0],trunk[2],thickness_trunk_minmax[1]);

// ARMS | HANDS
	// C
	d_arm_minmax=[10,40];			// 	d_arm=lim(d_arm_minmax[0],arm[0],d_arm_minmax[1]);
								//	d_arm=lim(d_pin+1,arm[0],d_arm_minmax[1]);	
	h_arm_minmax=[5,25];			// 	h_arm=lim(h_arm_minmax[0],arm[1],h_arm_minmax[1]);
	armpit_minmax=[0.3,60];		//	armpit=lim(armpit_minmax[0],arm[2],armpit_minmax[1]);
	l_arm_minmax=[20,120];		// 	l_arm=lim(d_arm+d_hand,arm[2],l_arm_minmax[1]);	

	d_hand_minmax=[10,60];		//	d_hand=lim(d_hand_minmax[0],hand[0],d_hand_minmax[1]);
	h_hand_minmax=[3,25];			//	h_hand=lim(h_hand_minmax[0],hand[1],h_arm-0.5);
	angle_hand_minmax=[0,180];	//	angle_hand=lim(angle_hand_minmax[0],hand[2]/2,angle_hand_minmax[1]);

	// Q
	x_arm_minmax=[5,25];			// 	x_arm=lim(x_arm_minmax[0],arm[1],x_arm_minmax[1]);
	y_arm_minmax=[10,40];			// 	y_arm=lim(y_arm_minmax[0],arm[0],y_arm_minmax[1]);
	z_arm_minmax=[20,120];		//	z_arm=lim(y_arm+5+d_hand,arm[2],z_arm_minmax[1]);

	n_hand_minmax=[4,12];			// 	n_hand=lim(n_hand_minmax[0],2*floor(hand[2]/2),n_hand_minmax[1]);
								//	h_hand=lim(h_hand_minmax[0],hand[1],x_arm-0.5);

// HEAD | EYES | BRAIN
	// C
	h_head_minmax=[20,100];		// 	h_head=lim(h_head_minmax[0],head[2],h_head_minmax[1]);
	d1_head_minmax=[20,60];		// 	d1_head=lim(d1_head_minmax[0],head[0],d1_head_minmax[1]);
	d2_head_minmax=[15,150];		// 	d2_head=lim(d2_head_minmax[0],head[1],2*h_head+d1_head);

	// Q
	x_head_minmax=[20,100];		// x_head=lim(x_head_minmax[0],head[0],x_head_minmax[1]);
	y_head_minmax=[20,100];		// y_head=lim(y_head_minmax[0],head[1],y_head_minmax[1]);
	z_head_minmax=[20,100];		// z_head=lim(z_head_minmax[0],head[2],z_head_minmax[1]);

	d_eye_minmax=[5,40];			// 	d_eye=lim(d_eye_minmax[0],eye[0],(d1_head+d2_head)/2);
	h_eye_minmax=[1,10];			// 	h_eye=lim(h_eye_minmax[0],eye[1],h_eye_minmax[1]);
	edge_eye_minmax=[1,12];		//	edge_eye=lim(edge_eye_minmax[0],eye[2],d_eye/2-3);

	frown_eye_expression_minmax=[0,100];		// frown_eye_expression=lim(frown_eye_expression_minmax[0],eye_expression[1],frown_eye_expression_minmax[1]);
	bridge_eye_position_minmax=[0,100];		// bridge_eye_position=lim(bridge_eye_position_minmax[0],eye_position[0],bridge_eye_position_minmax[1]);	
	f_h_eye_position_minmax=[0,100];			// f_h_eye_position=lim(f_h_eye_position_minmax[0],eye_position[1],f_h_eye_position_minmax[1]);	

	h_brain_minmax=[0,40];			//	h_brain=lim(h_brain_minmax[0],brain[0],h_brain_minmax[1]);
	edge_brain_minmax=[0,25];			//	edge_brain=lim(edge_brain_minmax[0],brain[1],edge_brain_minmax[1]);

	// S
	ds_head_minmax=[10,60];			//ds_head=lim(ds_head_minmax[0],head[1],ds_head_minmax[1]);	
	hs_head_minmax=[20,100];			//hs_head=lim(ds_head,head[2],hs_head_minmax[1]);
	db_head_minmax=[15,150];			//db_head=lim(db_head_minmax[0],head[0],db_head_minmax[1]);	

//BADGE
	d_badge_minmax=[20,40];		//	d_badge=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1])
	h_badge_minmax=[0.5,5];		// 	h_badge=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1]);
	n_badge_minmax=[4,50];		// 	n_badge=lim(n_badge_minmax[0],badge[3],n_badge_minmax[1]);
	edge_badge_minmax=[1,5];		//	edge_badge=lim(edge_badge_minmax[0],badge[2],edge_badge_minmax[1]);



