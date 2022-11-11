/*******************************************************************
*
*  DESCRIPCION: RTAtomic
*
*  AUTORES: Ezequiel Glinsky
*
*  EMAIL:   mailto://eglinsky@dc.uba.ar
*
*  FECHA: 01/08/2001
*******************************************************************/
#ifndef __RTATOMIC_H
#define __RTATOMIC_H

#include <list.h>
#include "atomic.h"     	// class Atomic
#include "atomicstate.h"	//
#include "VTime.hh"


class RTAtomic : public Atomic
{
public:
	RTAtomic( const string &name = "RTAtomic" );
	virtual string className() const {  return "RTAtomic" ;}
protected:
	Model &initFunction();
	Model &externalFunction( const ExternalMessage & );
	Model &internalFunction( const InternalMessage & );
	Model &outputFunction( const CollectMessage & );

	ModelState* allocateState() {
		return new AtomicState;
	}

private:
	const Port &in;
	Port &out;

	VTime preparationTime;
	int intDelay;
	int extDelay;    

};	// class RTAtomic

#endif   //__RTATOMIC_H

