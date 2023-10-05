import pybamm


def NMC_ocp_Siegel(sto):
    """
    Nickel Managanese Cobalt Oxide (NMC) Open Circuit Potential (OCP) as a
    function of the stochiometry. The fit is taken from Peyman MPM.

    References
    ----------
    Peyman MPM manuscript (to be submitted)

    Parameters
    ----------
    sto : :class:`pybamm.Symbol`
       Stochiometry of material (li-fraction)

    """
    # old function fitted between 0 and 1 stoic
    # u_eq = (
    #     4.396
    #     - 1.538 * sto
    #     + 0.7194 * (sto ** 2)
    #     - 0.009979 * (sto ** 3)
    #     + 1.074 * (sto ** 4)
    #     - 1.075 * (sto ** 5)
    #     - 4.071 * pybamm.exp(75 * sto - 80.9)
    # )

    p1 = -2253.9364
    p2 = 10756.6071
    p3 = -21755.8183
    p4 = 24277.2504
    p5 = -16299.5659
    p6 = 6728.9153
    p7 = -1670.2785
    p8 = 233.2321
    p9 = -18.3223
    p10 = 5.3936

    u_eq =  p1*sto**9 + p2*sto**8 + p3*sto**7 + p4*sto**6 + p5*sto**5 + p6*sto**4 + p7*sto**3 + p8*sto**2 + p9*sto + p10

    return u_eq


# if __name__ == "__main__":  # pragma: no cover
#     x = pybamm.linspace(0, 1)
#     pybamm.plot(x, NMC_ocp_PeymanMPM(x))
