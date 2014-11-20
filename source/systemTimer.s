/*
 * GetSystemTimerBase
 *
 * Input:
 * 	None
 *
 * Output:
 *  r0 - Timer base address
 *
 */
.global GetSystemTimerBase
GetSystemTimerBase:
	ldr r0, =0x20003000
	mov pc, lr


/*
 * GetTimeStamp
 *
 * Input:
 * 	None
 *
 * Output:
 *  r0 - Low order bits of the 32bit time stamp
 *  r1 - High order bits of the 32bit time stamp
 *
 */
.global GetTimeStamp
GetTimeStamp:
	push {lr}
	bl GetSystemTimerBase
	ldrd r0, r1, [r0, #4]
	pop {pc}
	

/*
 * wait
 *
 * Input:
 * 	r0 - delay
 *
 */
.global wait
wait:
	delay .req r2
	mov delay, r0
	
	push {lr}
	bl GetTimeStamp
	start .req r3
	mov start, r0
	
	loop$:
		bl GetTimeStamp
		elapsed .req r1
		sub elapsed, r0, start
		
		cmp elapsed, delay
		.unreq elapsed
		bls loop$
	
	.unreq delay
	.unreq start
	
	pop {pc}
	