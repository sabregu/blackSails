class Embarcacion{
    var property capitan
    var property contramaestre
    var property tripulacion
    const property caniones
    var property ubicacion
    var property botin

    method poderDeDanio() = tripulacion.sum{tripulante => tripulante.danioArmasTotal()} + caniones.sum{canion => canion.danio()}
    method eliminarTripulantesCobardes(){
        const lista = tripulacion.losMasCobardes().take(3)
        tripulacion.forEach{tripulante => if(lista.contains(tripulante)){tripulacion.remove(tripulante)}}
    }
    method losMasCobardes() = self.tripulantesSincapitanNiContramaestre().sortedBy{tripulante1,tripulante2 => tripulante2.corajeTotal() > tripulante1.corajeTotal()}
    method los3MasCorajudos() = self.losMasCobardes().reverse().take(3)
    method elMasCorajudo() = self.losMasCobardes().reverse().take(1)
    method agregarTripulacion(lista) = tripulacion.addAll(lista)
    method tieneTripulanteInteligente(cant) = tripulacion.any{tripulante => tripulante.inteligencia() > cant}
    method aumentarBotin(num) {botin += num}
    method tripulantesSincapitanNiContramaestre() = tripulacion.filter{tripulante => tripulante != capitan and tripulante != contramaestre}
    method oceano() = ubicacion.get(0)
    method coordenadax() = ubicacion.get(1)
    method coordenaday() = ubicacion.get(2)
}


class Tripulante{
    const tipoTripulante
    var corajeBase
    const property corajeTotal
    var property armas
    const property inteligencia

    method corajeBase() = self.min(100,corajeBase)
    method cambiarCorajeBase(nuevoCoraje){corajeBase = self.min(100,nuevoCoraje)}
    method aumentarCorajeBase(num) {corajeBase += num}
    method danioArmasTotal() = armas.sum{arma => arma.danio()}
    method tipoTripulante() = tipoTripulante.nombre()

    method min(a,b){if(a>b) return b else return a}
    method max(a,b){if(a<b) return b else return a}
}

class Capitan{
    const property nombre = "capitan"
}

class Contramaestre{
    const property nombre = "contramaestre"
}

class TripulacionGeneral{
    const property nombre = "tripulante"
}
// const pepe = new Tripulante(tipoTripulante = new Capitan(),corajeBase= 0,corajeTotal=0,armas=[],inteligencia=0)
class Caniones{
    const danio = 350
    var property aniosAntiguedad = 0

    method envejecerCanion() = aniosAntiguedad+1

    method danio() = danio - 0.01*aniosAntiguedad
}

class Cuchillo{
    method danio(pirata) = cuchillo.danio()
    method cambiarDanio(nuevoDanio) {cuchillo.danio(nuevoDanio)}
}

object cuchillo{
    var property danio = 0
}

class Espada{
    var property danio
}

class Pistola{
    const property calibre
    const property material

    method danio(pirata) = calibre * material.indice()
}

class Material{
    const property nombre
    const property indice
}

class Insulto{
    const property insulto

    method danio(pirata) = insulto.size() * pirata.corajeBase()
}

class Contienda{
    const property requisito
    const property efecto
    const property valorDistancia

method puedenEntrarEnCombate(embarcacion1,embarcacion2){
    const distanciaEmbarcaciones = ((embarcacion1.coordenadax()-embarcacion2.coordenadax())**2 + (embarcacion1.coordenaday()-embarcacion2.coordenaday())**2).squareRoot()

    embarcacion1.oceano() == embarcacion2.oceano() && distanciaEmbarcaciones < valorDistancia
}

method contienda(embarcacion1,embarcacion2){
    if(requisito.cumple(embarcacion1,embarcacion2)){
        efecto.cumplir(embarcacion1,embarcacion2)
    }
}
}

object efectoClasicaBatalla{
    method cumplir(embarcacion1,embarcacion2){
        embarcacion1.tripulacion().aumentarCoraje(5)
        embarcacion2.eliminarTripulantesCobardes(3)
        embarcacion2.capitan(embarcacion1.contramaestre())
        embarcacion1.contramaestre(embarcacion1.elMasCorajudo())
        embarcacion2.agregarTripulacion(embarcacion1.los3MasCorajudos())
    }
}

object efectoNegociacion{
    method cumplir(embarcacion1,embarcacion2){
        embarcacion1.aumentarBotin(embarcacion2.botin()/2)
    }
}

object criterioPoderEmbarcacion{
    method cumple(embarcacion1,embarcacion2) = embarcacion1.poderDeDanio() > embarcacion2.poderDeDanio()
}

class CriterioInteligencia{
    const property cant

    method cumple(embarcacion1,embarcacion2) = embarcacion1.tieneTripulanteInteligente(cant)
}

object clasicaBatalla{
    method batalla(embarcacion1,embarcacion2){
        if(embarcacion1.poderDeDanio() > embarcacion2.poderDeDanio()){
            embarcacion1.tripulacion().aumentarCoraje(5)
            embarcacion2.eliminarTripulantesCobardes(3)
            embarcacion2.capitan(embarcacion1.contramaestre())
            embarcacion1.contramaestre(embarcacion1.elMasCorajudo())
            embarcacion2.agregarTripulacion(embarcacion1.los3MasCorajudos())
        }
    }
}
