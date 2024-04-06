
object casaDePepeYJulian {
	var property cantidadDeViveres = 40
	var property montoParaReparaciones = 0
	var property cuentaAsignada = cuentaCorriente
	var property estrategiaAhorro = full
	
	method hayViveresSuficientes() {
		return cantidadDeViveres > 40
	}
	
	method hayQueHacerReparaciones() {
		return montoParaReparaciones > 0
	}
	
	method laCasaEstaEnOrden() {
		return self.hayViveresSuficientes() && not self.hayQueHacerReparaciones()
	}
	
	method agregarReparacion(valor) {
		montoParaReparaciones += valor
	}
	
	method comprarViveres(porcentaje, calidad) {
		cuentaAsignada.extraer(porcentaje * calidad)		
		cantidadDeViveres += porcentaje
	}
	
	method reparar() {
		cuentaAsignada.extraer(montoParaReparaciones)
		montoParaReparaciones = 0
	}
	
	method puedePagar(monto, resto) {
		return cuentaAsignada.saldo() - montoParaReparaciones > resto
	}
	
	method mantener() {
		estrategiaAhorro.mantener(self)
	}
}

object cuentaCorriente {
	var saldo = 0
	
	method depositar(dinero){
		saldo += dinero
	}
	
	method extraer(dinero){
		saldo -= dinero
	}
	
	method saldo(){
		return saldo
	}
}

object cuentaConGastos {
	var saldo = 0
	var property costoOperacion = 0
	
	method depositar(dinero){
		saldo += dinero - costoOperacion
	}
	
	method extraer(dinero){
		saldo -= dinero
	}
	
	method saldo(){
		return saldo
	}
}

object cuentaCombinada {
	var cuentaPrimaria = cuentaCorriente
	var cuentaSecundaria = cuentaConGastos
	
	method depositar(dinero){
		cuentaPrimaria.depositar(dinero)
	}
	
	method cuentaPrimaria(_cuenta){
		cuentaPrimaria = _cuenta
	}
	
	method cuentaSecundaria(_cuenta){
		cuentaSecundaria = _cuenta
	}
	
	
	method extraer(dinero){
		if(self.saldoSuficiente(dinero)) {cuentaPrimaria.extraer(dinero)}
			else {cuentaSecundaria.extraer(dinero)}
	}
	
	method saldoSuficiente(dinero){
		return cuentaPrimaria.saldo() > dinero
	}
	
	method saldo(){
		return cuentaPrimaria.saldo() + cuentaSecundaria.saldo()
	}
}

object estrategiaMinimoEIndispensable {
	var property calidad = 1
	var property hogar = casaDePepeYJulian
	
	method mantener(casa){
		const porcentaje = if(not casa.hayViveresSuficientes()) self.loqueFaltaDeViveres() else 0
		
		casa.comprarViveres(porcentaje, calidad)
	
	}
	
	method loqueFaltaDeViveres(){
		return (40 - self.hogar().cantidadDeViveres())
	}
	
}

object full{
	var property hogar = casaDePepeYJulian
	
	method mantener(casa) {
		const porcentaje = if(casa.laCasaEstaEnOrden()) 100 - casa.cantidadDeViveres() else 40 
		
		casa.comprarViveres(porcentaje, 5)
		if(casa.puedePagar(casa.montoParaReparaciones(), 1000)) {
			casa.reparar()
		}	
	}
	
	method gastoDeViveres(){
		if (self.hogar().laCasaEstaEnOrden())
		  {return (100 - hogar.cantidadDeViveres()) * 5}
		  else {return 200}
	}
	
}























