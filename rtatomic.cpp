/*******************************************************************
*
*  DESCRIPCION: RTAtomic
*
*  AUTOR: Ezequiel Glinsky
*
*  EMAIL: mailto://eglinsky@dc.uba.ar
*
*  FECHA: 01/08/2001
*******************************************************************/

#include <string.h>
#include "rtatomic.h"
#include "message.h"
#include "parsimu.h"
#include "dhry.h"

/*******************************************************************/
/** Global Constants **/
//const bool RTDEVS_DEBUG = true;
const bool RTDEVS_DEBUG = false;
/*******************************************************************/

/*******************************************************************
* CLASS RTAtomic
*********************************************************************/

/*******************************************************************
* Nombre de la Funci�n: RTAtomic::RTAtomic()
* Descripci�n: Constructor
********************************************************************/
RTAtomic::RTAtomic( const string &name ) : Atomic( name )
    , in( addInputPort( "in" ) )
	, out( addOutputPort( "out" ) )
	, preparationTime( 0, 0, 0, 1 )
{
    
	string time( ParallelMainSimulator::Instance().getParameter( description(), "preparation" ) ) ;
    string timeIntDelay( ParallelMainSimulator::Instance().getParameter( description(), "intDelay" ) ) ;    
	string timeExtDelay( ParallelMainSimulator::Instance().getParameter( description(), "extDelay" ) ) ;    
    
	if( time != "" )
		preparationTime = time ;
	if( timeIntDelay != "" )
		intDelay = atoi ( timeIntDelay.c_str() );
	if( timeExtDelay != "" )
		extDelay = atoi ( timeExtDelay.c_str() );

}


/*******************************************************************
* Nombre de la Funci�n: RTAtomic::initFunction()
* Descripci�n: Funci�n de Inicializaci�n
********************************************************************/

Model &RTAtomic::initFunction()
{
	return *this ;
}


/*******************************************************************
* Nombre de la Funci�n: RTAtomic::externalFunction()
* Descripci�n: Maneja los eventos externos (nuevas solicitudes y aviso de "listo"
********************************************************************/

Model &RTAtomic::externalFunction( const ExternalMessage &msg )
{
    if (RTDEVS_DEBUG)
    {
    	cerr << "RTAtomic - External Function in " << description() << endl;
    	cerr << "    # Dhry                              : " << extDelay << endl;
    	cerr << "    RTAtomic::externalFunction STARTS at:  " << ParallelMainSimulator::Instance().elapsedTime().asString() << endl ;
    }

    ParallelMainSimulator::Instance().incExternalRuns();

    dhrystoneRun (extDelay);

    if (RTDEVS_DEBUG)
    {
	cerr << "    RTAtomic::externalFunction ENDS   at:  " << ParallelMainSimulator::Instance().elapsedTime().asString() << endl ;
    }
    holdIn( AtomicState::active, preparationTime );

	return *this;
}

/*******************************************************************
* Nombre de la Funci�n: RTAtomic::internalFunction()
* Descripci�n: Pone el modelo en estado pasivo (esperando un "Done" o algo para enviar)
********************************************************************/
Model &RTAtomic::internalFunction( const InternalMessage & )
{

    if (RTDEVS_DEBUG)
    {
    	cerr << "RTAtomic - Internal Function in " << description()  << endl;
    	cerr << "    # Dhry                              : " << intDelay << endl;
    	cerr << "    RTAtomic::internalFunction STARTS at:  " << ParallelMainSimulator::Instance().elapsedTime().asString() << endl ;
    }

    ParallelMainSimulator::Instance().incInternalRuns();

    dhrystoneRun (intDelay);

    if (RTDEVS_DEBUG)
    {
 	   cerr << "    RTAtomic::internalFunction ENDS   at:  "  << ParallelMainSimulator::Instance().elapsedTime().asString() << endl ;
    }

    passivate();
	return *this ;
}


/*******************************************************************
* Nombre de la Funci�n: RTAtomic::outputFunction()
* Descripci�n: Env�a solicitud al receptor
********************************************************************/
Model &RTAtomic::outputFunction( const CollectMessage &msg )
{
	sendOutput( msg.time(), out, 1 ) ;
	return *this ;
}

